# UmlautThreeSixtyLink
[![Build Status](https://api.travis-ci.org/mlibrary/umlaut-three-sixty-link.png?branch=master)](https://travis-ci.org/mlibrary/umlaut-three-sixty-link)

A gem to use 360 Link's API with [Umlaut](https://github.com/team-umlaut/umlaut).

## Installation

1. Install umlaut in the usual way.
1. Add `gem 'umlaut'` to your `Gemfile`.
1. Run `bundle install`.
1. Add a service to `config/umlaut_services.yml`.

    ```yaml
    # ...
    default:
        services:
            ThreeSixtyLink:
            type: ThreeSixtyLink
            display_name: 360 Link
            base_url: http://<your-libhash>.openurl.xml.serialssolutions.com/openurlxml
            priority: 3
    # ...
    ```

## Contributing

[Bug reports and pull requests are welcome on GitHub](https://github.com/mlibrary/umlaut-three-sixty-link).

Copyright (c) 2016, Regents of the University of Michigan.  
All rights reserved. See [LICENSE.txt](LICENSE.txt) for details.
