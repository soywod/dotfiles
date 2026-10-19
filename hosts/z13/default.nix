{
  imports = [
    ../common.nix
    ./hardware-configuration.nix
    (import ./disko.nix { })
  ];

  # Let the iGPU address ~105 GB of unified memory (default is half of
  # RAM), so large local LLMs fit. Value is in 4 KiB pages.
  boot.kernelParams = [
    "ttm.pages_limit=27525120"
    "ttm.page_pool_size=27525120"
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
