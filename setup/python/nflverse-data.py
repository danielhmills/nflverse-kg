import pandas as pd

df, df2 = pd.read_csv('../../data/csv/play_by_play_2023.csv'), pd.read_csv('../../data/csv/play_by_play_2023.csv')
columns_to_drop = df.columns[df.columns.str.contains('epa|name|vegas|_prob|wpa|wp|xyac|player|team')]
df.drop(columns=columns_to_drop, inplace=True)
df.rename(columns={'desc': 'play_description'}, inplace=True)

df2 = df2.filter(regex='play_id|game_id|player|team')
#filtered_columns.to_csv('filtered_dataframe.csv', index=False)

df.to_csv('../../data/csv/prepared/play_by_play_2023_plays.csv', index=False)
df2.to_csv('../../data/csv/prepared/play_by_play_2023_plays_players_teams.csv', index=False)