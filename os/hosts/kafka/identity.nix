{config, ...}: {
  services.openssh = {
    generateHostKeys = false;
    hostKeys = [
      {path = config.security.nix-secrets.secrets."os/hosts/kafka/sshd/ssh_host_ed25519_key".path;}
      {path = config.security.nix-secrets.secrets."os/hosts/kafka/sshd/ssh_host_rsa_key".path;}
    ];
  };
  networking.hostName = "kafka"; # REMOVEME
}
