{ config, lib, pkgs, ... }:
{

  #hardware.amdgpu.initrd.enable = true;
  boot.kernelModules = [
    "nvidia"
    #"amdgpu" 
  ];
  boot.initrd.kernelModules = [ 
    "nvidia" 
    #"amdgpu" 
  ];
  boot.extraModulePackages = [ config.boot.kernelPackages.lenovo-legion-module config.boot.kernelPackages.nvidia_x11 ];
  boot.kernelParams = [ 
    "nvidia_drm.fbdev=1" 
    "nvidia-drm.modeset=1" 
    "module_blacklist=amdgpu" 
  ];

  hardware.graphics = {
    enable = lib.mkDefault true;
    enable32Bit = lib.mkDefault true;
  };

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [
    "nvidia" 
    "modesetting" 
    #"amdgpu" 
  ];

  hardware.nvidia = {

#    prime = {     
#       # Nvidia Offload for hybrid setups      
#      offload.enable = true;
#			 offload.enableOffloadCmd = true;
#      
#       # Prime Sync offers better performance at reduced screen tearing at the cost of higher power consumption
#      sync.enable = true; # Needs offload disabled
      
#       # Enable if using an external GPU (only when using reverseSync) 
#      allowExternalGpu = true;
#      reverseSync.enable = true; # can't be used with offload enabled
#
#    # Make sure to use the correct Bus ID values for your system!
#    amdgpuBusId = "PCI:5:0:0";
#    nvidiaBusId = "PCI:1:0:0";
#    };
    
    # Ensures all GPUs stay awake even during headless mode
    nvidiaPersistenced = true;

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    # requires nvidia offload mode enabled
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
