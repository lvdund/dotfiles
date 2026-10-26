## Debian 13 with Swaywm

1. Install:

2. Screen - no off:
```bash
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target

sudo mkdir -p /etc/systemd/logind.conf.d
sudo nano /etc/systemd/logind.conf.d/99-no-sleep.conf
```

```ini
[Login]
IdleAction=ignore
HandleSuspendKey=ignore
HandleHibernateKey=ignore
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
```

3. Login:

Check the service account first:
```bash
getent passwd _greetd
```

If Debian uses greeter instead, set user = "greeter". Before enabling greetd, make sure Sway can launch from a text TTY. Then:
```bash
sudo systemctl enable greetd
```

If GDM, LightDM, or SDDM is currently installed, disable that display manager before rebooting so it does not conflict with greetd.

```bash
sudo systemctl disable --now gdm3.service
sudo systemctl enable --now greetd.service
```
