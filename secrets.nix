(
  (
    secrets: key:
      builtins.listToAttrs (
        map (name: {
          inherit name;
          value = {
            publicKeys = [key];
          };
        })
        secrets
      )
  )
  [
    "os/common/u-hashed-password.age"
    "os/hosts/kafka/sshd/ssh_host_ed25519_key.age"
    "os/hosts/kafka/sshd/ssh_host_ed25519_key.pub.age"
    "os/hosts/kafka/sshd/ssh_host_rsa_key.age"
    "os/hosts/kafka/sshd/ssh_host_rsa_key.pub.age"
    "os/hosts/kafka/luks-password.age"
    "os/hosts/firefly/sshd/ssh_host_ed25519_key.age"
    "os/hosts/firefly/sshd/ssh_host_ed25519_key.pub.age"
    "os/hosts/firefly/sshd/ssh_host_rsa_key.age"
    "os/hosts/firefly/sshd/ssh_host_rsa_key.pub.age"
    "os/hosts/firefly/luks-password.age"
    "home/git/identities/dawn-wine-joker.age"
    "home/git/identities/gh-joker.age"
    "home/git/identities/gh-ren.age"
    "home/git/identities/gl-ren.age"
    "home/jj/conf.d/dawn-wine-joker.toml.age"
    "home/jj/conf.d/gh-joker.toml.age"
    "home/jj/conf.d/gh-ren.toml.age"
    "home/jj/conf.d/gl-ren.toml.age"
    "home/ssh/joker/id_ed25519.pub.age"
    "home/ssh/joker/id_ed25519.age"
    "home/ssh/ren/id_ed25519.pub.age"
    "home/ssh/ren/id_ed25519.age"
  ]
  "age17h6qkhtuwhvgt8mtf62ut0hjujp46rurufd5mtq54wxses8ww9kqvl09eq"
)
