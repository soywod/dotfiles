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
    firewall.interfaces.wlp194s0.allowedTCPPorts = [
      3000 # standard API port
      5173 # vite dev
      4173 # vite preview
    ];
  };

  # Folding the keyboard cover trips the lid switch: keep running instead
  # of suspending (sway powers the panel off, see home.nix).
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
  };
}
