{ ... }:
{
  console.useXkbConfig = true;


  services = {
    xserver.xkb = {
      layout = "m4w";
      extraLayouts = {
        m4w = {
          description = "Swiss German (custom AltGr)";
          languages = [ "deu" ];
          symbolsFile = ./symbols_custom_altgr;
        };
      };
    };

    udev.extraHwdb = ''
      evdev:atkbd:*
        KEYBOARD_KEY_01=capslock
        KEYBOARD_KEY_3a=esc

      *
        KEYBOARD_KEY_70029=capslock
        KEYBOARD_KEY_70039=esc
    '';
  };
}
