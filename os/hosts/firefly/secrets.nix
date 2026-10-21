{
  age.secrets = {
    "kafka/sshd/ssh_host_ed25519_key".file = ../kafka/sshd/ssh_host_ed25519_key.age; # tag:fix
    "kafka/sshd/ssh_host_ed25519_key.pub".file = ../kafka/sshd/ssh_host_ed25519_key.pub.age; # tag:fix
    "kafka/sshd/ssh_host_rsa_key".file = ../kafka/sshd/ssh_host_rsa_key.age; # tag:fix
    "kafka/sshd/ssh_host_rsa_key.pub".file = ../kafka/sshd/ssh_host_rsa_key.pub.age; # tag:fix
    "firefly/sshd/ssh_host_ed25519_key".file = ./sshd/ssh_host_ed25519_key.age;
    "firefly/sshd/ssh_host_ed25519_key.pub".file = ./sshd/ssh_host_ed25519_key.pub.age;
    "firefly/sshd/ssh_host_rsa_key".file = ./sshd/ssh_host_rsa_key.age;
    "firefly/sshd/ssh_host_rsa_key.pub".file = ./sshd/ssh_host_rsa_key.pub.age;
    "firefly/luks-password".file = ./luks-password.age;
  };
}
