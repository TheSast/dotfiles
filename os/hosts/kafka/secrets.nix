{
  age.secrets = {
    "kafka/sshd/ssh_host_ed25519_key".file = ./sshd/ssh_host_ed25519_key.age;
    "kafka/sshd/ssh_host_ed25519_key.pub".file = ./sshd/ssh_host_ed25519_key.pub.age;
    "kafka/sshd/ssh_host_rsa_key".file = ./sshd/ssh_host_rsa_key.age;
    "kafka/sshd/ssh_host_rsa_key.pub".file = ./sshd/ssh_host_rsa_key.pub.age;
    "kafka/luks-password".file = ./luks-password.age;
  };
}
