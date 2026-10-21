{config, ...}: {
  services.openssh = {
    generateHostKeys = false;
    hostKeys = [
      {path = config.age.secrets."firefly/sshd/ssh_host_ed25519_key".path;}
      {path = config.age.secrets."firefly/sshd/ssh_host_rsa_key".path;}
      {path = config.age.secrets."kafka/sshd/ssh_host_ed25519_key".path;} # tag:fix
      {path = config.age.secrets."kafka/sshd/ssh_host_rsa_key".path;} # tag:fix
    ];
  };
  networking.hostName = "firefly";
}
