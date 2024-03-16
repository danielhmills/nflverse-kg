ALTER TABLE nflverse.kg.plays
    MODIFY COLUMN game_id VARCHAR;
ALTER TABLE nflverse.kg.plays ADD COLUMN play_id_varchar VARCHAR(255);
UPDATE nflverse.kg.plays SET play_id_varchar = CAST(play_id AS VARCHAR);
ALTER TABLE nflverse.kg.plays MODIFY PRIMARY KEY (ID_pk);
ALTER TABLE nflverse.kg.plays DROP COLUMN play_id;
ALTER TABLE nflverse.kg.plays ADD COLUMN play_id VARCHAR;
UPDATE nflverse.kg.plays SET play_id = play_id_varchar;
ALTER TABLE nflverse.kg.plays DROP COLUMN play_id_varchar;
ALTER TABLE nflverse.kg.plays
    MODIFY PRIMARY KEY (game_id, play_id);
ALTER TABLE nflverse.kg.plays_players_teams
    MODIFY PRIMARY KEY (game_id, play_id);
CREATE INDEX idx_game_play ON nflverse.kg.plays (game_id, play_id); 
CREATE INDEX idx_game_play_players_teams ON nflverse.kg.plays_players_teams (game_id, play_id); 

ALTER TABLE nflverse.kg.plays_players_teams ADD COLUMN play_id_varchar VARCHAR(255);
UPDATE nflverse.kg.plays_players_teams SET play_id_varchar = CAST(play_id AS VARCHAR);
ALTER TABLE nflverse.kg.plays_players_teams MODIFY PRIMARY KEY (ID_pk);
ALTER TABLE nflverse.kg.plays_players_teams DROP COLUMN play_id;
ALTER TABLE nflverse.kg.plays_players_teams ADD COLUMN play_id VARCHAR;
UPDATE nflverse.kg.plays_players_teams SET play_id = play_id_varchar;
ALTER TABLE nflverse.kg.plays_players_teams DROP COLUMN play_id_varchar;

ALTER TABLE nflverse.kg.players
ADD COLUMN college_uri VARCHAR;

UPDATE nflverse.kg.players SET college_uri = REPLACE(college_uri,' ','_');

ALTER TABLE nflverse.kg.players
ADD COLUMN college_conference_uri VARCHAR;

UPDATE nflverse.kg.players SET college_conference_uri = REPLACE(college_conference,' ','_');

log_enable(3);
UPDATE nflverse.kg.plays SET drive_time_of_possession =  ('P'||REPLACE(drive_time_of_possession,':','M')||'S');

UPDATE nflverse.kg.plays SET drive_game_clock_start =  REPLACE(('P'||REPLACE(drive_game_clock_start,':','M')||'S'), 'PS', 'P0M0S');

UPDATE nflverse.kg.plays SET drive_game_clock_end =  REPLACE(('P'||REPLACE(drive_game_clock_end,':','M')||'S'), 'PS', 'P0M0S');


