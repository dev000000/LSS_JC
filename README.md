# Linux Shell Scripting — Jason Cannon (Project-Based)

My practice repo for the Udemy course
[**Linux Shell Scripting: A Project-Based Approach to Learning**](https://www.udemy.com/course/linux-shell-scripting-projects/).
In the course you learn Bash by building six sysadmin tools on CentOS 7 VMs managed with Vagrant + VirtualBox.
Each lesson is logged as a [GitHub issue](https://github.com/dev000000/Linux-Shell-Scripting-Jason_Cannon/issues).

## Projects

| # | Script | What it does |
|---|---|---|
| 1 | [`add-local-user.sh`](localusers/exercises/add-local-user.sh) | Prompts for a username, name and password, then creates the account and forces a password change at first login |
| 2 | [`add-new-local-user.sh`](localusers/exercises/add-new-local-user.sh) | Takes the username and comment as arguments and generates a random password |
| 3 | [`add-newer-local-user.sh`](localusers/exercises/add-newer-local-user.sh) | Same as #2, but follows Unix conventions: errors go to STDERR, command noise goes to `/dev/null` |
| 4 | [`disable-local-user.sh`](localusers/exercises/disable-local-user.sh) | Disables, deletes (`-d`) or archives (`-a`) accounts, optionally removing home directories (`-r`). Skips system accounts |
| 5 | [`show-attackers.sh`](localusers/exercises/show-attackers.sh) | Prints a CSV of IPs with more than 10 failed SSH logins, with each IP's country |
| 6 | [`run-everywhere.sh`](multinet/exercises/run-everywhere.sh) | Runs one command on many servers over SSH. Options: dry run `-n`, sudo `-s`, verbose `-v`, server list `-f` |

## Requirements

- [VirtualBox](https://www.virtualbox.org/wiki/Downloads), [Vagrant](https://developer.hashicorp.com/vagrant/downloads) and [Git](https://git-scm.com/downloads)
- VT-x/AMD-V enabled in BIOS
- Windows only: disable Hyper-V, and run `git config --global core.autocrlf input` before cloning so scripts keep LF line endings

## Setup

```bash
git clone https://github.com/dev000000/Linux-Shell-Scripting-Jason_Cannon.git
cd Linux-Shell-Scripting-Jason_Cannon
vagrant box add jasonc/centos7
```

**Projects 1–5** run on a single VM:

```bash
cd localusers && vagrant up && vagrant ssh
cd /vagrant            # the host's localusers/ folder, shared into the VM
```

**Project 6** runs on three VMs: `admin01` (192.168.56.10), `server01` (.11) and `server02` (.12):

```bash
cd multinet && vagrant up && vagrant ssh admin01
# on admin01, one-time setup:
echo "192.168.56.11 server01" | sudo tee -a /etc/hosts
echo "192.168.56.12 server02" | sudo tee -a /etc/hosts
ssh-keygen                                   # press Enter at every prompt
ssh-copy-id server01 && ssh-copy-id server02 # password: vagrant
cd /vagrant
```

## Project structure

```
.
├── documents/        # Course handouts for Exercises 1–7 (PDF)
├── testbox01/        # Exercise 1: first test VM
├── multitest/        # Exercise 1: two-VM test
├── localusers/       # Projects 1–5
│   ├── Vagrantfile
│   ├── demos/        # luser-demo01–14.sh: scripts from the course videos + access_log sample
│   ├── exercises/    # Exercise 2–6 solutions + syslog-sample
│   └── lessons/      # 01–10: my study notes written as scripts
├── multinet/         # Project 6
│   ├── Vagrantfile   # admin01, server01, server02
│   ├── demos/        # multinet-demo01.sh (ping check) + servers list
│   ├── exercises/    # run-everywhere.sh
│   └── lessons/      # 11: SSH and remote-command notes
└── .claude/skills/study-log/   # Claude Code skill: one issue + one commit per lesson
```

- **demos/**: scripts from the course videos, with my notes added
- **exercises/**: my solutions to the PDF exercises
- **lessons/**: reference notes. Copy commands one by one instead of running the file; some lines delete users or files

## Usage

Scripts are not executable in git. Inside the VM, run them with `bash` (add `sudo` when needed):

```bash
sudo bash exercises/add-new-local-user.sh dstamper Doug Stamper
sudo bash exercises/disable-local-user.sh -dra dstamper
bash exercises/show-attackers.sh exercises/syslog-sample
bash exercises/run-everywhere.sh -v -s id        # on admin01, as vagrant (not root)
```

## Learning log

- One issue per lesson. The title is `N.<topic>`; the body holds the course lesson title, an `(S<section>-L<lecture>)` tag and the key points.
- Commits follow Conventional Commits (`lesson(scope): …`, `fix`, `refactor`, `chore`, `docs`) and end with `Refs: #N`.

## Notes

- Run scripts **only inside the VMs**: they create, lock and delete users.
- If `vagrant up` rejects the `10.9.8.x` IPs in `testbox01/` or `multitest/`, add `* 10.0.0.0/8 192.168.0.0/16` to `/etc/vbox/networks.conf` on the host.
- CentOS 7 is end-of-life, so `yum install` needs the repos switched to `vault.centos.org`.

---

Course and exercise handouts © Jason Cannon / [Linux Training Academy](https://www.linuxtrainingacademy.com/). Solutions and notes by [@dev000000](https://github.com/dev000000).
