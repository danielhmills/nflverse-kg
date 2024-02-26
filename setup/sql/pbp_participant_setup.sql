DROP PROCEDURE nflverse_pbp_procedure_split;
DROP TABLE nflverse.kg.plays_participation_ext IF EXISTS;

CREATE TABLE nflverse.kg.plays_participation_ext 
AS
SELECT 
    nflverse_game_id,
    play_id,
    offense_personnel,
    defense_personnel,
    players_on_play,
    offense_players,
    defense_players

FROM nflverse.kg.plays_participation;

ALTER TABLE nflverse.kg.plays_participation_ext
    ADD COLUMN running_back_count INTEGER;
ALTER TABLE nflverse.kg.plays_participation_ext
    ADD COLUMN tight_end_count INTEGER;
ALTER TABLE nflverse.kg.plays_participation_ext
    ADD COLUMN wide_receiver_count INTEGER;
ALTER TABLE nflverse.kg.plays_participation_ext
    ADD COLUMN defensive_line_count INTEGER;
ALTER TABLE nflverse.kg.plays_participation_ext
    ADD COLUMN linebacker_count INTEGER;
ALTER TABLE nflverse.kg.plays_participation_ext
    ADD COLUMN defensive_back_count INTEGER;
    
CREATE PROCEDURE nflverse_pbp_procedure_split(){

    DECLARE state, msg, descs, rows, nflverse_game_id, play_id, offense_personnel, defenders_in_box, defense_personnel, players_on_play, offense_players, defense_players, entries  any;
    DECLARE _idx INTEGER;
    EXEC('SELECT nflverse_game_id, play_id, offense_personnel, defense_personnel, players_on_play, offense_players, defense_players FROM nflverse.kg.plays_participation', state, msg, vector (), null, descs, rows);
    _idx := 1;
    WHILE(_idx < LENGTH(rows)){ 
        nflverse_game_id := rows[_idx][0];
        play_id := rows[_idx][1];
        offense_personnel := SPLIT_AND_DECODE(CAST(rows[_idx][2] AS VARCHAR),0,'\0\0,');
        defense_personnel := SPLIT_AND_DECODE(CAST(rows[_idx][3] AS VARCHAR),0,'\0\0,');
        offense_players := SPLIT_AND_DECODE(CAST(rows[_idx][5] AS VARCHAR),0,'\0\0;');
        defense_players := SPLIT_AND_DECODE(CAST(rows[_idx][6] AS VARCHAR),0,'\0\0;');
        IF(LENGTH(offense_players) > 0){
            FOREACH (ANY player IN offense_players) DO{
                EXEC(SPRINTF('INSERT INTO nflverse.kg.plays_participation_ext VALUES (\'%s\',\'%s\',null,null,null,\'%s\',null,null,null,null,null,null,null)', nflverse_game_id,play_id,player));
            }
        }
        IF(LENGTH(defense_players) > 0){
            FOREACH (ANY player IN defense_players) DO{
                EXEC(SPRINTF('INSERT INTO nflverse.kg.plays_participation_ext VALUES (\'%s\',\'%s\',null,null,null,null,\'%s\',null,null,null,null,null,null)', nflverse_game_id,play_id,player));
            }
        }
        
        VECTORBLD_INIT(entries);

        IF(LENGTH(offense_personnel) > 0){
            FOREACH (ANY player IN offense_personnel) DO{
                IF(LENGTH(player) > 0){
                    VECTORBLD_ACC(entries,REGEXP_MATCH('\\d',player));
                }
                ELSE{
                    VECTORBLD_ACC(entries,null);
                }
            }
        }
        ELSE{
            VECTORBLD_ACC(entries,'');
            VECTORBLD_ACC(entries,'');
            VECTORBLD_ACC(entries,'');
        }
        IF(LENGTH(defense_personnel) > 0){
            FOREACH (ANY player IN defense_personnel) DO{
                IF(LENGTH(player) > 0){
                    VECTORBLD_ACC(entries,REGEXP_MATCH('\\d',player));
                }
                ELSE{
                    VECTORBLD_ACC(entries,null);
                }
            }
        }
        ELSE{
            VECTORBLD_ACC(entries,'');
            VECTORBLD_ACC(entries,'');
            VECTORBLD_ACC(entries,'');
        }
        VECTORBLD_FINAL(entries);
        EXEC(SPRINTF('INSERT INTO nflverse.kg.plays_participation_ext (nflverse_game_id, play_id,running_back_count, tight_end_count, wide_receiver_count, defensive_line_count, linebacker_count, defensive_back_count) VALUES (\'%s\',\'%s\',\'%s\',\'%s\',\'%s\',\'%s\',\'%s\',\'%s\')', nflverse_game_id, play_id, entries[0], entries[1], entries[2], entries[3], entries[4], entries[5]));
       _idx := _idx + 1;
    } ;
};

SELECT nflverse_pbp_procedure_split();
SELECT * FROM nflverse.kg.plays_participation_ext