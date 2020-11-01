# cable_ready.cr

This is a Crystal port of the [CableReady](https://github.com/hopsoft/cable_ready) Ruby library.

**Disclaimer:** This library is still WIP and is not meant to be used in production yet!

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     cable_ready:
       github: marcoroth/cable_ready
   ```

2. Run `shards install`

## Usage

```crystal
require "cable_ready"
```

This port supports all DOM operations of the original library. Have a look at the [CableReady docs](https://cableready.stimulusreflex.com/usage/dom-operations).

### Client-side

Install the `cable_ready` npm package with `yarn add cable_ready` and establish a websocket connection to the backend.

Here is an example in Amber:

```javascript
// src/assets/javascripts/main.js

import Amber from 'amber';
import CableReady from 'cable_ready';

let socket = new Amber.Socket('/cable');

socket.connect().then(() => {
  let channel = socket.channel('cable_ready:xyz');
  channel.join();

  channel.on('message', (message) => {
    if (message.message.cableReady) {
      CableReady.perform(message.message.operations);
    }
  })
});
```

### Server-side

The Ruby library uses `snake_case` for the operation names. Currently this port just supports the `camelCase` variants of the operation names.

You can include the `CableReady::Broadcaster` module in whatever class you want to send a broadcast from. Here is an example:

```crystal
include CableReady::Broadcaster

# use "innerHtml" here instead of "inner_html"
cable_ready["CableReady"].innerHtml({
  :selector => "#clock",
  :html => "#{Time.local}"
})

cable_ready.broadcast
```

#### Setup in Amber

In Amber you can create a `Socket` class and setup a `Channel` class to send the CableReady operations down to the client. You can generate them with:

```bash
amber g socket cable_ready
amber g channel cable_ready
```

With `channel "cable_ready:*", CableReadyChannel` you can delegate the connection to a specific channel:

```crystal
# src/sockets/cable_ready_socket.cr

struct CableReadySocket < Amber::WebSockets::ClientSocket
  channel "cable_ready:*", CableReadyChannel

  def on_connect
    # do some authentication here
    # return true or false, if false the socket will be closed
  
    true
  end
end
```

This is how the `CableReadyChannel` looks like:

```crystal
# src/sockets/cable_ready_socket.cr
class CableReadyChannel < Amber::WebSockets::Channel
  def handle_joined(client_socket, message)
  end

  def handle_message(client_socket, message)
  end

  def handle_leave(client_socket)
  end
end
```

Now you can setup some DOM operations where ever in the app you want to send down an update to the client. For example in a controller:

```crystal
# src/controllers/home_controller.cr

class HomeController < ApplicationController
  include CableReady::Broadcaster

  def index
    cable_ready["CableReady"].innerHtml({
      :selector => "#clock",
      :html => "#{Time.local}"
    })

    cable_ready.broadcast

    render("index.ecr")
  end
end
```

Make sure you also setup a route for the Socket in `config/routes.cr`

```crystal
# config/routes.cr

Amber::Server.configure do

 # ...
 
 routes :web do
	# ...
   websocket "/cable", CableReadySocket
 end
 
 # ...
 
end
```


## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/marcoroth/cable_ready/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Nate Hopkins](https://github.com/hopsoft) - creator of the original [CableReady](https://github.com/hopsoft/cable_ready) Ruby library
- [Marco Roth](https://github.com/marcoroth) - creator and maintainer
