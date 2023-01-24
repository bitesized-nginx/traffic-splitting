# Traffic Splitting Example
This repository provides a basic example of traffic splitting using the NGINX [ngx_http_split_clients_module](https://nginx.org/en/docs/http/ngx_http_split_clients_module.html).

It includes a sample scenario that you can explore and modify.  See the "Getting Started" section below.

## Requirements
This example requires that you have docker and docker-compose installed. See the [docker installation page](https://docs.docker.com/get-docker/) for more details.

## Getting Started
This example uses the official [NGINX docker image](https://hub.docker.com/_/nginx) and [Livebook](https://livebook.dev/) to provide an interactive example of traffic splitting.

1. Clone this repository: `git clone https://github.com/bitesized-nginx/traffic-splitting.git`
1. From the root directory of the project, run `docker-compose up`
1. In browser, navigate to: `http://0.0.0.0:8080/`
1. Click on `traffic_splitting.livemd`, then the blue "open" button
   upper right.

## How to Use

Instructions are provided in the notebook and you can follow the instructions.  Each "cell" will have an "evaluate" button on the upper left corner when you hover your cursor over it.  Clicking that will perform the action in the shell.

### Do I need to know Elixir to use this?
Nope! Livebook is a powerful tool for writing composable interactive examples with tutorial content inline which is why it was chosen. However, we've set it up in such a way that you don't need to know any Elixir to use it.

You may have to enter numerical values into Elixir code from time to time, but it should be self explanatory.  For example take the following code block:

```elixir
NginxLivebookUtils.TrafficGenerator.run("frontend", "/", call_count: 100, call_delay_ms: 500)
```
In order to send more or less traffic, you'll just need to modify the number to the right of `call_count`.  To insert a small delay between each call, change the number to the right of `call_delay_ms` to the number of milliseconds the generator should sleep between requests.

However, if you are interested in learning Elixir, See the official [Getting Started Guide](https://elixir-lang.org/getting-started/introduction.html) or [Elixir School](https://elixirschool.com). This tool is called [Livebook](https://livebook.dev/).  If you do, you'll be able to easily modify the generated diagrams, and create more robust examples if you'd like to do other measurements.

## Contributing

Please see the [contributing guide](https://github.com/bitesized-nginx/traffic-splitting/blob/main/CONTRIBUTING.md) for guidelines on how to best contribute to this project.

## License

[Apache License, Version 2.0](https://github.com/bitesized-nginx/traffic-splitting/blob/main/LICENSE)

&copy; [F5, Inc.](https://www.f5.com/) 2023
