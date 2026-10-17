{
  imports = [
    ../common.nix
    ./hardware-configuration.nix
    (import ./disko.nix { })
  ];

  networking = {
    hostName = "z13";
    # Vite dev (5173) + preview (4173), reachable from the phone on wifi only.
    firewall.interfaces.wlp194s0.allowedTCPPorts = [
      5173
      4173
    ];
  };
}
