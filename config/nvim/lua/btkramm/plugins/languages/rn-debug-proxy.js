const WebSocket = require("ws");
const net = require("net");
const url = require("url");

class RNDebugProxy {
  constructor() {
    this.sourceMapCache = new Map();
    this.scriptIdToUrl = new Map();
    this.breakpointRetryMap = new Map();
    this.server = net.createServer((socket) => this.handleConnection(socket));
  }

  handleConnection(socket) {
    const ws = new WebSocket(
      "ws://localhost:8081/debugger-proxy?role=debugger",
    );
    let msgIdCounter = 1;

    ws.on("open", () => {
      console.log("Connected to React Native debugger");
    });

    socket.on("data", (data) => {
      const messages = data
        .toString()
        .split("\n")
        .filter((msg) => msg.trim());

      messages.forEach((message) => {
        try {
          const parsed = JSON.parse(message);

          // Handle different message types
          if (parsed.method) {
            this.handleDebuggerToAppMessage(parsed, ws);
          } else {
            // Regular request
            ws.send(JSON.stringify(parsed));
          }
        } catch (e) {
          console.error("Failed to parse message:", e);
          ws.send(message);
        }
      });
    });

    ws.on("message", (data) => {
      try {
        const parsed = JSON.parse(data.toString());

        // Handle different response types
        if (parsed.method) {
          this.handleAppToDebuggerMessage(parsed, socket);
        } else {
          // Regular response
          socket.write(JSON.stringify(parsed) + "\n");
        }
      } catch (e) {
        socket.write(data.toString() + "\n");
      }
    });

    socket.on("close", () => ws.close());
    ws.on("close", () => socket.destroy());
  }

  handleDebuggerToAppMessage(message, ws) {
    // Block unsupported commands that crash Hermes
    if (message.method === "Debugger.setBlackboxPatterns") {
      return;
    }

    // Track breakpoint requests for retry logic
    if (message.method === "Debugger.setBreakpointByUrl") {
      this.breakpointRetryMap.set(message.id, message.params);
    }

    ws.send(JSON.stringify(message));
  }

  handleAppToDebuggerMessage(message, socket) {
    // Process source map registration
    if (message.method === "Debugger.scriptParsed" && message.params) {
      this.registerSourceMap(message.params);
    }

    // Fix console logs with hidden stack info
    if (message.method === "Runtime.consoleAPICalled" && message.params) {
      this.fixConsoleStack(message.params);
    }

    // Handle breakpoint retry for Fast Refresh
    if (message.id && this.breakpointRetryMap.has(message.id)) {
      const result = message.result;
      if (result && result.locations && result.locations.length === 0) {
        // Breakpoint failed, might need retry after Fast Refresh
        console.log("Breakpoint set failed, may retry after Fast Refresh");
      }
      this.breakpointRetryMap.delete(message.id);
    }

    // Debounce resume events to prevent UI flicker
    if (message.method === "Debugger.resumed") {
      setTimeout(() => {
        socket.write(JSON.stringify(message) + "\n");
      }, 100);
      return;
    }

    socket.write(JSON.stringify(message) + "\n");
  }

  fixConsoleStack(params) {
    const args = params.args || [];

    // React Native console wrapper adds file info as last 3 arguments:
    // [...actualArgs, scriptURL, lineNumber, columnNumber]
    if (args.length >= 3) {
      const columnArg = args[args.length - 1];
      const lineArg = args[args.length - 2];
      const urlArg = args[args.length - 3];

      // Check if these look like stack info
      if (
        urlArg?.value &&
        typeof urlArg.value === "string" &&
        urlArg.value.includes("bundle") &&
        typeof lineArg?.value === "number" &&
        typeof columnArg?.value === "number"
      ) {
        // Remove the hidden stack arguments
        params.args = args.slice(0, -3);

        // Add proper stack trace if not already present
        if (!params.stackTrace || !params.stackTrace.callFrames.length) {
          params.stackTrace = {
            callFrames: [
              {
                functionName: "",
                scriptId: "0",
                url: this.normalizeUrl(urlArg.value),
                lineNumber: lineArg.value - 1, // CDP uses 0-based line numbers
                columnNumber: columnArg.value - 1,
              },
            ],
          };
        }
      }
    }

    // Filter out internal messages
    if (args.length > 0 && args[0]?.value?.startsWith?.("__RNIDE_INTERNAL")) {
      params.args = [];
    }
  }

  registerSourceMap(params) {
    if (params.url) {
      this.scriptIdToUrl.set(params.scriptId, params.url);
    }

    if (params.sourceMapURL) {
      // Normalize source map URL for different device configurations
      const normalized = this.normalizeUrl(params.sourceMapURL);
      this.sourceMapCache.set(params.scriptId, {
        url: params.url,
        sourceMapURL: normalized,
      });
    }
  }

  normalizeUrl(inputUrl) {
    // Handle Android emulator's special IP
    if (inputUrl.includes("10.0.2.2")) {
      return inputUrl.replace("10.0.2.2", "localhost");
    }

    // Handle iOS simulator localhost variations
    if (inputUrl.includes("127.0.0.1")) {
      return inputUrl.replace("127.0.0.1", "localhost");
    }

    return inputUrl;
  }

  start(port = 9229) {
    this.server.listen(port, () => {
      console.log(`React Native debug proxy listening on port ${port}`);
      console.log("Configure your debugger to connect to this port");
      console.log("Start your React Native app and enable remote debugging");
    });
  }
}

// Start the proxy
new RNDebugProxy().start();
