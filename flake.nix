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
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        db = devDB.outputs.packages.${system};
      in
      {
        devShell = with pkgs; mkShell {
          nativeBuildInputs = [ bashInteractive ];
          buildInputs = [
            R
            postgresql_15
            db.start-database
            db.stop-database
            db.psql-wrapped
            pgadmin4-desktopmode
            dbeaver-bin
            rPackages.dbplyr
            rPackages.usethis
            rPackages.lehdr
            rPackages.tidyUSDA
            rPackages.blscrapeR
            rPackages.pagedown
            rPackages.tidyverse
            rPackages.sf
            rPackages.terra
            rPackages.leaflet
            rPackages.leaflet_extras
            rPackages.crsuggest
            rPackages.ggridges
            rPackages.geofacet
            rPackages.ggbeeswarm
            rPackages.leaflet_extras2
            rPackages.leafsync
            rPackages.spdep
            rPackages.ggiraph
            rPackages.maps
            rPackages.segregation
            rPackages.corrr
            rPackages.car
            rPackages.spatialreg
            rPackages.GWmodel
            rPackages.survey
            rPackages.httr
            rPackages.jsonlite
            rPackages.srvyr
            rPackages.tidygeocoder
            rPackages.ipumsr
            rPackages.RPostgres
            rPackages.trajr
            rPackages.devtools
            rPackages.flowmapblue
            rPackages.tidycensus
            rPackages.censusapi
            rPackages.worldbank
            rPackages.wbstats
            rPackages.spocc
            rPackages.chirps
            rPackages.rosm
            rPackages.mapboxapi
            rPackages.elevatr
            rPackages.patchwork
            rPackages.XML
            rPackages.rnaturalearth
            rPackages.rnaturalearthdata
            rPackages.osmdata
            rPackages.lwgeom
            rPackages.rmapshaper
            rPackages.rcartocolor
            rPackages.shiny
            rPackages.mapview
            rPackages.mapdeck
            rPackages.ggspatial
            rPackages.cartogram
#            rPackages.USAboundaries
            rPackages.gifski
            rPackages.historydata
            rPackages.viridis
            rPackages.tmap
            rPackages.plotly
            rPackages.geodata
            rPackages.tidyterra
            rPackages.htmlwidgets
            rPackages.webshot
            rPackages.spData
            rPackages.codetools
            chromium
            pandoc
            texlive.combined.scheme-full
            rstudio
          ];
          shellHook = ''
            export PG_ROOT=$(git rev-parse --show-toplevel)
          '';
        };
      }
    );
}
