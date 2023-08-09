# RE-stall

Set of installation scripts for programs that I often use.

Installing programs on fresh Arch install has never been easier.

---

## Scripts description

### PHP

- `composer-install.sh` - installs composer globally and sets up PATH variable
- `php-install.sh` - sets up newest php, including settings in `php.ini` and `php-fpm, php-cgi`
- `php-legacy-install.sh` - same as above, but for legacy php version
- `php-post-install.sh` - move php binaries to `~/.php/bin` and symlink the correct version to `/usr/bin`
    - this script also creates pacman hook to move the binaries when php update happens

**TODO**

- [ ] make the post install pacman hook script

- [ ] use array iteration for moving newly installed binaries

- [ ] version php-fpm service -> `ls /usr/lib/systemd/system | grep php`

- [ ] mby use laravel prompts and create interactive **pvm** script
