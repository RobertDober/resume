defmodule Resume do
  @moduledoc """
  A Phoenix app to create CVS

  ## Beta Version

  Define your CVs in `cvs` directory according to this structure

          cvs/<lang>/<version>/config.yml
          cvs/<lang>/<version>/cv.yml
        
  E.g.

          cvs
          |-- en
          |   `-- 2.0.0
          |       |-- config.yml
          |       `-- cv.yml
          |-- fr
          |   |-- 2.0.0
          |   |   |-- config.yml
          |   |   `-- cv.yml
          |   `-- 2.0.2
          |       |-- config.yml
          |       `-- cv.yml
          `-- tag_clouds
              `-- webdev_cloud.txt

  As `cvs` will probably contain confidential data it is not included into the sources, for the convenience of the
  user she can copy `cvs_examples` to `cvs` start the phoenix server and go to `localhost:4000` to see the examples
  
  Right now there is only one template and output is optimized for printing only.

  ## Roadmap
  
  - More templates. (v1) 

  - Styling for screen. (v1)

  - Themes. (v2?)
  """
end
