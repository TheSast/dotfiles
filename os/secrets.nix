{inputs, ...}: {
  imports = [
    inputs.agenix.nixosModules.default
  ];
  age = {
    identityPaths = ["/dur/nixos_age_key"];
    secrets = {
      u-hashed-password.file = ./u-hashed-password.age;
      root-hashed-password.file = ./root-hashed-password.age;
      "kafka/sshd/ssh_host_ed25519_key".file = ./kafka/sshd/ssh_host_ed25519_key.age;
      "kafka/sshd/ssh_host_ed25519_key.pub".file = ./kafka/sshd/ssh_host_ed25519_key.pub.age;
      "kafka/sshd/ssh_host_rsa_key".file = ./kafka/sshd/ssh_host_rsa_key.age;
      "kafka/sshd/ssh_host_rsa_key.pub".file = ./kafka/sshd/ssh_host_rsa_key.pub.age;
      "kafka/luks-password".file = ./kafka/luks-password.age;
      "firefly/sshd/ssh_host_ed25519_key".file = ./firefly/sshd/ssh_host_ed25519_key.age;
      "firefly/sshd/ssh_host_ed25519_key.pub".file = ./firefly/sshd/ssh_host_ed25519_key.pub.age;
      "firefly/sshd/ssh_host_rsa_key".file = ./firefly/sshd/ssh_host_rsa_key.age;
      "firefly/sshd/ssh_host_rsa_key.pub".file = ./firefly/sshd/ssh_host_rsa_key.pub.age;
      "firefly/luks-password".file = ./firefly/luks-password.age;
    };
  };
}
