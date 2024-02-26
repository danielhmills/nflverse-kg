ALTER TABLE nflverse.kg.plays
    MODIFY PRIMARY KEY (game_id, play_id);
ALTER TABLE nflverse.kg.plays_players_teams
    MODIFY PRIMARY KEY (game_id, play_id);
CREATE INDEX idx_game_play ON nflverse.kg.plays (game_id, play_id); 
CREATE INDEX idx_game_play_players_teams ON nflverse.kg.plays_players_teams (game_id, play_id); 

