# ansible-role-nfs-client

Configure NFSv3 client.

## Notes about NFSv4

NFSv4 is not yet supported.

# Requirements

None

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `nfs_client_mount` | list of mount configurations. see below  | `[]` |

## FreeBSD-specific Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `nfs_client_lockd_flags` | options for `lockd` | `""` |
| `nfs_client_statd_flags` | options for `statd` | `""` |

## Debian/Ubuntu-specific Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `nfs_client_rpcbind_flags` | options for `rpcbind` | `""` |
| `nfs_client_nfs_common_flags` | dict to override `nfs_client_nfs_common_flags_default` | `{}` |
| `nfs_client_nfs_common_flags_default` | dict of variables for `/etc/default/nfs-common` | see below |

### `nfs_client_nfs_common_flags_default`

```yaml
nfs_client_nfs_common_flags_default:
  NEED_GSSD: ""
  STATDOPTS: ""
```

## `nfs_client_mount`

A list of NFS mount settings. Element is a dict of mount settings, which is
described below.

| Key | Description | Mandatory |
|-----|-------------|-----------|
| `path`  | mount point | yes |
| `src`   | remote NFS path to mount | yes |
| `opts`  | mount options | yes |
| `state` | one of `present`, `absent`, `mounted`, or `unmounted` | yes |

```yaml

```

# Dependencies

None

# Example Playbook

## FreeBSD

```yaml
- hosts: localhost
  roles:
    - ansible-role-nfs-client
  vars:
    nfs_client_statd_flags: "-h {{ ansible_default_ipv4.address }}"
    nfs_client_lockd_flags: "-h {{ ansible_default_ipv4.address }}"
    nfs_client_mount:
      - path: /mnt
        src: 127.0.0.1:/exports/foo
        opts: ro
        # do not mount, just modify fstab(5). NFS server is not available in
        # the test environment
        state: present
```

## Ubuntu

```yaml
- hosts: localhost
  roles:
    - ansible-role-nfs-client
  vars:
    nfs_client_rpcbind_flags: -w
    nfs_client_mount:
      - path: /mnt
        src: 127.0.0.1:/exports/foo
        opts: ro
        # do not mount, just modify fstab(5). NFS server is not available in
        # the test environment
        state: present
```

## CentOS

```yaml
- hosts: localhost
  roles:
    - ansible-role-nfs-client
  vars:
    nfs_client_mount:
      - path: /mnt
        src: 127.0.0.1:/exports/foo
        opts: ro
        # do not mount, just modify fstab(5). NFS server is not available in
        # the test environment
        state: present
```

## OpenBSD

```yaml
- hosts: localhost
  roles:
    - ansible-role-nfs-client
  vars:
    nfs_client_mount:
      - path: /mnt
        src: 127.0.0.1:/exports/foo
        opts: ro
        # do not mount, just modify fstab(5). NFS server is not available in
        # the test environment
        state: present
```

# License

```
Copyright (c) 2017 Tomoyuki Sakurai <tomoyukis@reallyenglish.com>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```

# Author Information

Tomoyuki Sakurai <tomoyukis@reallyenglish.com>

This README was created by [qansible](https://github.com/trombik/qansible)
