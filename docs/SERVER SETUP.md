# Server Emulator Setup

## 1. Port Forwarding & Networking

Forward the following ports on the hosting server IP:

* **TCP:** `28002`, `28003`, `28004`, `28005`
* **UDP:** `22000`

### UDP Listener Sockets
Assign UDP listener sockets starting from port `28006` onward for consistency. It is recommended to configure **5 to 10 UDP listener ports**.

### Network Setup Types
* **LAN / Virtual LAN (Hamachi, RadminVPN, ZeroTier):** You do not need to worry about external IPs. On a local LAN, set all configuration IPs to your internal IP. If using a tunneling program, use the IP assigned by that application.
* **Online (Internet):** Use your public/external IP address where required in the configuration.

---

## 2. Server Configuration (HJSON)

Configure the HJSON server configuration files as shown below. Update database credentials (`username`, `password`) to match your local setup.

### Auth Config (`auth.hjson`)

```hjson
{
  listener: [Your Internal IP Here]:28002
  max_connections: 500
  api:
  {
    listener: 127.0.0.1:27000
    serverlist_timeout: 30000
  }
  noob_mode: false
  auto_register: true
  database:
  {
    engine: MySQL
    auth:
    {
      filename: ..\db\auth.db
      host: localhost
      port: 3306
      username: root
      password: null
      database: auth
    }
  }
}
```

#### Settings Overview:
* **`noob_mode`**: Allows any account to be overridden and logged into without restriction. (Recommended: `false`)
* **`auto_register`**: Automatically creates a new account if the login credentials do not exist.

---

### Game Config (`game.hjson`)

```hjson
{
  server_name: [S4 Server Name Here]
  server_id: 1
  server_ip: [Your External IP here]
  listener: [Your Internal IP here]:28003
  listener_chat: [Your Internal IP here]:28004
  listener_relay: [Your Internal IP here]:28005
  listener_relay_udp_ports: [28006 , 28007 , 28008 , 28009 , 28010 , 28011 , 28012 , 28013 , 28014 , 28015]
  listener_threads: 1
  worker_threads: 8
  player_limit: 500
  security_level: 0
  auth_webapi:
  {
    endpoint: 127.0.0.1:27000
    serverlist_update_interval: 25000
  }
  save_interval: 60000
  noob_mode: false
  database:
  {
    engine: MySQL
    auth:
    {
      filename: ..\db\auth.db
      host: localhost
      port: 3306
      username: root
      password: null
      database: auth
    }
    game:
    {
      filename: ..\db\game.db
      host: localhost
      port: 3306
      username: root
      password: null
      database: game
    }
  }
  game:
  {
    enable_tutorial: false
    enable_license_requirement: false
    max_level: 101
    start_level: 40
    start_pen: 900000
    start_ap: 900000
    start_coins1: 0
    start_coins2: 0
    durability_loss_per_death: 0
    durability_loss_per_minute: 0
    nick_restrictions:
    {
      min_length: 4
      max_length: 30
      max_repeat: 3
      allow_whitespace: false
      only_ascii: true
    }
    exp_rates_touchdown:
    {
      score_factor: 0.7
      first_place_bonus: 50
      second_place_bonus: 30
      third_place_bonus: 10
      player_count_factor: 0.06
      exp_per_min: 20
    }
    exp_rates_deathmatch:
    {
      score_factor: 0.7
      first_place_bonus: 50
      second_place_bonus: 30
      third_place_bonus: 10
      player_count_factor: 0.06
      exp_per_min: 20
    }
    exp_rates_chaser:
    {
      exp_per_first_point: 5
      exp_per_second_point: 3
      exp_per_third_point: 2
      score_factor: 0.7
      first_place_bonus: 50
      second_place_bonus: 30
      third_place_bonus: 10
      player_count_factor: 0.06
      exp_per_min: 20
    }
    exp_rates_battleroyal:
    {
      score_factor: 0.7
      first_place_bonus: 50
      second_place_bonus: 30
      third_place_bonus: 10
      player_count_factor: 0.06
      exp_per_min: 20
    }
    exp_rates_captain:
    {
      exp_per_first_point: 5
      exp_per_second_point: 3
      exp_per_third_point: 2
      score_factor: 0.7
      first_place_bonus: 50
      second_place_bonus: 30
      third_place_bonus: 10
      player_count_factor: 0.06
      exp_per_min: 20
    }
  }
}
```

#### Settings Overview:
* **`listener_relay_udp_ports`**: Expand array as needed to match allocated UDP ports.
* **`listener_threads` & `worker_threads`**: Adjust higher based on system CPU cores for better performance.
* **`noob_mode`**: Must match the `noob_mode` setting in `auth.hjson`.

---

## 3. Windows Permissions & Firewall Setup

1. **Administrator Rights:**  
   Navigate to the server folder, right-click `Auth.exe` and `Game.exe`, go to **Properties > Compatibility**, and check **Run this program as an administrator**.
2. **Firewall Rules:**  
   Open Windows Firewall and add inbound rule exceptions for `Auth.exe` and `Game.exe`. Ensure both **Domain/Private** and **Public** options are checked.
