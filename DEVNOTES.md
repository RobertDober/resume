# Application Layout

        <root>
           ┗━ cvs
              ┣━ fr
              ┃ ┣━ <cv_name>
              ┃ ┃ ┣━ config.yml (1)
              ┃ ┃ ┗━ cv.yml (2)
              ┃ ┗━ <cv_name>
              ┃    ...
              ┗━ en
                 ...

## `config.yml` (1)
contains configuration concerning the title and renderers
Format:

         name: YHS
         title: Cool Developer
         renderers:
           - simple-cv (*)

(*)  the renderer simply points to a Phoenix template directory in the standard directory
`lib/resume_web/templates/cv/simple-cv` of which the `show.html.eex` is rendered.

## `cv.yml` (2)

There are examples inside the [`cvs_examples`](cvs_examples/en/2.0.0/cv.yml) directory.
