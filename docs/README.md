# Keyboard Repeat Rate

```
defaults read NSGlobalDomain KeyRepeat
defaults read NSGlobalDomain InitialKeyRepeat
```

```
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 20
```

# Ansible

`cd ansible && ansible-playbook ./playbooks/initialize-development-environment.yaml --limit "mac_os"`
