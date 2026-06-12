{ herdrPkg, herdrSrc, neovim, web, pkgs, ... }:
let
  username = "rtorresware";
  home = "/Users/${username}";
  prefix = "${home}/.npm-packages";
in
{
  programs = {
    zsh.enable = true;
    fish = {
      enable = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;  # Better Nix + direnv integration
    };
  };

  system.stateVersion = 6;
  system.primaryUser = username;
  networking.hostName = "macbook-2";
  environment.shells = [ pkgs.fish ];
  users.knownUsers = [ username ];
  users.users.${username} = {
    home = home;
    uid = 501;
    shell = pkgs.fish;
  };
  nix.settings = {
    experimental-features = "nix-command flakes";
  };
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = false;
  home-manager.users.${username} =
    { pkgs, lib, ... }:
    let
      opencodeWebTool = pkgs.writeText "opencode-web-tool.ts" ''
        import { execFile } from "node:child_process"
        import { promisify } from "node:util"
        import { tool } from "@opencode-ai/plugin"

        const execFileAsync = promisify(execFile)

        export default tool({
          description:
            "Browse a web page with the rtorresware/web CLI. Use for JavaScript-heavy pages, screenshots, forms, Phoenix LiveView, or persistent browser profiles.",
          args: {
            url: tool.schema.string().describe("URL to open"),
            raw: tool.schema.boolean().optional().describe("Return raw HTML instead of markdown"),
            js: tool.schema.string().optional().describe("JavaScript to execute after the page loads"),
            screenshot: tool.schema.string().optional().describe("Path where a full-page screenshot should be saved"),
            profile: tool.schema.string().optional().describe("Named browser session profile for cookies/auth state"),
            truncateAfter: tool.schema.number().optional().describe("Maximum number of output characters"),
            form: tool.schema.string().optional().describe("Form id to submit"),
            inputs: tool.schema
              .array(
                tool.schema.object({
                  name: tool.schema.string().describe("Input name attribute"),
                  value: tool.schema.string().describe("Input value"),
                }),
              )
              .optional()
              .describe("Form input name/value pairs"),
            afterSubmit: tool.schema.string().optional().describe("URL to load after form submission"),
          },
          async execute(args) {
            const command = ["web", args.url]

            if (args.raw) command.push("--raw")
            if (args.js) command.push("--js", args.js)
            if (args.screenshot) command.push("--screenshot", args.screenshot)
            if (args.profile) command.push("--profile", args.profile)
            if (args.truncateAfter !== undefined) command.push("--truncate-after", String(args.truncateAfter))
            if (args.form) command.push("--form", args.form)
            for (const input of args.inputs ?? []) command.push("--input", input.name, "--value", input.value)
            if (args.afterSubmit) command.push("--after-submit", args.afterSubmit)

            try {
              const { stdout, stderr } = await execFileAsync(command[0], command.slice(1), {
                maxBuffer: 25 * 1024 * 1024,
              })

              return [stdout.trim(), stderr.trim()].filter(Boolean).join("\n\n")
            } catch (error) {
              const err = error as { code?: number | string; stdout?: string; stderr?: string; message?: string }
              return [
                `web exited with code ''${err.code ?? "unknown"}`,
                err.stderr?.trim(),
                err.stdout?.trim(),
                err.message,
              ]
                .filter(Boolean)
                .join("\n\n")
            }
          },
        })
      '';
    in
    {
      nixpkgs.config = {
        allowUnfree = true;
        input-fonts.acceptLicense = true;
      };
      home.stateVersion = "25.11";
      home.packages =
        [ herdrPkg neovim web ]
        ++ (with pkgs; [
          ripgrep
          nodejs
          direnv
          any-nix-shell
          go-2fa
          obsidian
          openssh
          input-fonts
          devenv
        ]);
      home.homeDirectory = home;
      home.sessionVariables = {
        GIT_EDITOR = "nvim";
        EDITOR = "nvim";
        PREFIX = prefix;
      };
      home.sessionPath = [
        "${home}/.opencode/bin"
        "${prefix}/bin"
        "${home}/.local/bin"
      ];
      xdg = {
        enable = true;
        configFile = {
          "herdr/config.toml".text = ''
            [theme]
            name = "terminal"
          '';
          "opencode/skills/herdr/SKILL.md".source = "${herdrSrc}/SKILL.md";
          "opencode/skills/web-browser/SKILL.md".text = ''
            ---
            name: web-browser
            description: Use when browsing web pages with rtorresware/web, especially JavaScript-heavy pages, screenshots, forms, Phoenix LiveView, or persistent session profiles.
            ---

            # Web Browser

            Use the `web` custom tool when a page needs browser behavior beyond static fetching.

            Prefer `web` for:

            - JavaScript-rendered pages
            - Screenshots
            - Form filling and submission
            - Phoenix LiveView pages
            - Authenticated flows using named profiles
            - Capturing browser console output with injected JavaScript

            Prefer built-in `webfetch` for simple static documentation pages where JavaScript, screenshots, forms, and sessions are unnecessary.
          '';
        };
      };
      home.activation.installOpencodeWebTool = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD mkdir -p "$HOME/.config/opencode/tools"
        $DRY_RUN_CMD install -m 0644 ${opencodeWebTool} "$HOME/.config/opencode/tools/web.ts"
      '';
      programs.git = {
        enable = true;
        settings.user = {
          name = "Rodolfo Torres";
          email = "rtorresware@gmail.com";
        };
      };
      programs.fish.enable = true;
    };
}
