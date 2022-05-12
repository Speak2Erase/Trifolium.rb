DROP TABLE IF EXISTS save_data;
DROP TABLE IF EXISTS inbox;
DROP TABLE IF EXISTS buddy_list;
DROP TABLE IF EXISTS user_data;
DROP TABLE IF EXISTS guilds;
DROP TABLE IF EXISTS ips;
DROP TABLE IF EXISTS users;

-- Registered Users

CREATE TABLE users (
	user_id INTEGER PRIMARY KEY,
	username TEXT NOT NULL UNIQUE,
	password TEXT NOT NULL,
	usergroup INTEGER NOT NULL default 0,
	banned INTEGER NOT NULL default 0,
	token TEXT NOT NULL default 0
)

-- IPs

CREATE TABLE ips (
	user_id INTEGER NOT NULL,
	ip TEXT NOT NULL,
	PRIMARY KEY (user_id, ip),
	FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
)

-- Guilds

CREATE TABLE guilds (
	guild_id INTEGER PRIMARY KEY,
	leader_id INTEGER NOT NULL UNIQUE,
	guildname TEXT NOT NULL UNIQUE,
	password TEXT NOT NULL,
	FOREIGN KEY (leader_id) REFERENCES users(user_id) ON DELETE CASCADE
)

-- Special User Data

CREATE TABLE user_data (
	user_id INTEGER NOT NULL,
	lastlogin DATETIME NOT NULL,
	guild_id INTEGER default NULL,
	PRIMARY KEY (user_id),
	FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
	FOREIGN KEY (guild_id) REFERENCES guilds(guild_id) ON DELETE SET NULL
)

-- Buddy List

CREATE TABLE buddy_list (
	user1_id INTEGER NOT NULL,
	user2_id INTEGER NOT NULL,
	PRIMARY KEY (user1_id, user2_id),
	FOREIGN KEY (user1_id) REFERENCES users(user_id) ON DELETE CASCADE,
	FOREIGN KEY (user2_id) REFERENCES users(user_id) ON DELETE CASCADE
)

-- PM Inbox Data

CREATE TABLE inbox (
	pm_id INTEGER PRIMARY KEY,
	recipient_id INTEGER  NOT NULL,
	sendername TEXT NOT NULL,
	senddate DATETIME NOT NULL,
	message text NOT NULL,
	unread INTEGER NOT NULL default 1,
	FOREIGN KEY (recipient_id) REFERENCES users(user_id) ON DELETE CASCADE
)

-- Saved Data

CREATE TABLE save_data (
	user_id INTEGER NOT NULL,
	data_name TEXT NOT NULL,
	data_value mediumblob NOT NULL,
	PRIMARY KEY (user_id, data_name),
	FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
)