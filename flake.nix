{
  description = "A basic flake with a shell";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    devDB.url = "github:hermann-p/nix-postgres-dev-db";
    devDB.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self, nixpkgs, flake-utils, devDB, ... }:
    let supportedSystems = [
         "x86_64-linux"
         "x86_64-darwin"
         "aarch64-linux"
         "aarch64-darwin"      
    ];
    in
    flake-utils.lib.eachSystem supportedSystems (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        db = devDB.outputs.packages.${system};
      in
      {
        devShells.default = with pkgs; mkShell {
          nativeBuildInputs = [ bashInteractive ];
          buildInputs = [
            R
            postgresql_15
            db.start-database
            db.stop-database
            db.psql-wrapped
            pgadmin4-desktopmode
            dbeaver-bin
            chromium
            pandoc
            texlive.combined.scheme-full
            rstudio
            quarto
            ( with rPackages; [
              dbplyr
              usethis
              lehdr
              tidyUSDA
              janitor
              blscrapeR
              pagedown
              tidyverse
              sf
              terra
              leaflet
              palmerpenguins
              positron-bin
              gt
              gtsummary
              leaflet_extras
              quarto
              crsuggest
              ggridges
              geofacet
              ggbeeswarm
              leaflet_extras2
              leafsync
              spdep
              ggiraph
              maps
              segregation
              corrr
              car
              spatialreg
              GWmodel
              survey
              httr
              jsonlite
              srvyr
              tidygeocoder
              ipumsr
              RPostgres
              trajr
              devtools
              flowmapblue
              tidycensus
              censusapi
              worldbank
              wbstats
              spocc
              chirps
              rosm
              mapboxapi
              elevatr
              patchwork
              XML
              rnaturalearth
              rnaturalearthdata
              osmdata
              lwgeom
              rmapshaper
              rcartocolor
              shiny
              mapview
              mapdeck
              cartogram
#            rPackages.USAboundaries
              gifski
              historydata
              viridis
              tmap
              plotly
              geodata
              tidyterra
              htmlwidgets
              webshot
              spData
              codetools]
          )];
          shellHook = ''
            export PG_ROOT=$(git rev-parse --show-toplevel)
          '';
        };
      }
    );
}
