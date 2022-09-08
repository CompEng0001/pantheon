{ pkgs }:
with pkgs;
let
  RStudio-with-my-packages = rstudioWrapper.override
    {
      packages = with rPackages;
        [
          janitor # https://www.rdocumentation.org/packages/janitor/versions/2.1.0
          knitr # https://www.rdocumentation.org/packages/knitr/versions/1.39
          lubridate
          mlr # https://www.rdocumentation.org/packages/mlr/versions/2.19.0
          mlr3 # https://www.rdocumentation.org/packages/mlr3/versions/0.14.0
          rjson # https://www.rdocumentation.org/packages/rjson/versions/0.2.21
          tidyjson # https://www.rdocumentation.org/packages/tidyjson/versions/0.3.1
          tidymodels # https://www.rdocumentation.org/packages/tidymodels/versions/1.0.0
          tidyverse # https://www.rdocumentation.org/packages/tidyverse/versions/1.3.2
          xmlconvert # https://www.rdocumentation.org/packages/xmlconvert/versions/0.1.2
          xtable # https://www.rdocumentation.org/packages/xtable/versions/1.8-4
        ];
    };
in
RStudio-with-my-packages
