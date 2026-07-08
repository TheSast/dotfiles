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
    "os/u-hashed-password.age"
    "os/root-hashed-password.age"
    "os/kafka/sshd/ssh_host_ed25519_key.age"
    "os/kafka/sshd/ssh_host_ed25519_key.pub.age"
    "os/kafka/sshd/ssh_host_rsa_key.age"
    "os/kafka/sshd/ssh_host_rsa_key.pub.age"
    "home/git/identities/gh-joker.age"
    "home/git/identities/gh-ren.age"
    "home/git/identities/gl-ren.age"
    "home/ssh/joker/id_ed25519.pub.age"
    "home/ssh/joker/id_ed25519.age"
    "home/ssh/ren/id_ed25519.pub.age"
    "home/ssh/ren/id_ed25519.age"
  ]
  "age17h6qkhtuwhvgt8mtf62ut0hjujp46rurufd5mtq54wxses8ww9kqvl09eq"
)
