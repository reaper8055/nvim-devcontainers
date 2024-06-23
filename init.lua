local Job = require("plenary.job")
local json = require("dkjson")

local function read_devcontainer_config()
  local config_path = "./devcontainer/devcontainer.json"
  local file = io.open(config_path, "r")
  if not file then error("could not open devcontainer.json") end
  local content = file:read("*a")
  file:close()
  return json.decode(content)
end

local function start_remove_server(container_id)
  Job:new({
    command = "docker",
    args = { "exec", "-it", container_id, "nvim", "--headless", "--listen", "localhost:6666" },
    on_exit = function(j, return_val)
      print("Remove server started with return value: ", return_val)
    end,
  }):start()
end

local function sync_fs(local_dir, remote_name, remote_dir)
  Job:new({
    command = "rclone",
    args = { "sync", local_dir, string.format("%s:%s", remote_name, remote_dir) },
    on_exit = function(j, return_val)
      print("FS synchronized with return value: ", return_val)
      print(table.concat(j:result(), "\n"))
      print(table.concat(j:stderr_result(), "\n"))
    end,
  }):start()
end

local function setup()
  local config = read_devcontainer_config()
  start_remove_server(config.container_id)
  sync_fs(config.local_dir, config.remote_name, config.remote_dir)
end

return {
  setup = setup,
}
