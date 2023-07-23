{ pkgs }:
with pkgs;
let
  RStudio-with-my-packages = rstudioWrapper.override
    {
      packages = with rPackages;
        [
          fuzzywuzzyR #https://www.rdocumentation.org/packages/fuzzywuzzyR/versions/1.0.5
          ggpubr # https://www.rdocumentation.org/packages/ggpubr/versions/0.6.0
          gtsummary # https://www.rdocumentation.org/packages/gtsummary/versions/1.6.3
          janitor # https://www.rdocumentation.org/packages/janitor/versions/2.1.0
          knitr # https://www.rdocumentation.org/packages/knitr/versions/1.39
          lubridate # https://www.rdocumentation.org/packages/lubridate/versions/1.8.0
          mlr # https://www.rdocumentation.org/packages/mlr/versions/2.19.0
          mlr3 # https://www.rdocumentation.org/packages/mlr3/versions/0.14.0
          moments # https://www.rdocumentation.org/packages/moments/versions/0.14.1
          padr # https://www.rdocumentation.org/packages/padr/versions/0.6.0
          pheatmap # https://www.rdocumentation.org/packages/pheatmap
          rjson # https://www.rdocumentation.org/packages/rjson/versions/0.2.21
          RMariaDB # https://www.rdocumentation.org/packages/RMariaDB/versions/1.2.2
          RMySQL # https://www.rdocumentation.org/packages/RMySQL/versions/0.10.23
          scater # https://www.rdocumentation.org/packages/scater/vesions/1.0.4
          stringdist # https://rdocumentation.org/packages/stringdist/versions/0.9.9
          TSstudio # https://www.rdocumentation.org/packages/TSstudio/versions/0.1.6
          tidyjson # https://www.rdocumentation.org/packages/tidyjson/versions/0.3.1
          tidymodels # https://www.rdocumentation.org/packages/tidymodels/versions/1.0.0
          tidyverse # https://www.rdocumentation.org/packages/tidyverse/versions/1.3.2
          timeSeries # https://www.rdocumentation.org/packages/timeSeries/versions/4021.105
          useful # https://www.rdocumentation.org/packages/useful/versions/1.2.6
          validate # https://www.rdocumentation.org/packages/validate/versions/1.1.1
          validatetools # https://www.rdocumentation.org/packages/validatetools/versions/0.5
          xmlconvert # https://www.rdocumentation.org/packages/xmlconvert/versions/0.1.2
          xtable # https://www.rdocumentation.org/packages/xtable/versions/1.8-4
        ];
    };
in
RStudio-with-my-packages
