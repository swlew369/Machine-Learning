# A study of the IMDB movie data downloaded from Kaggle
import pandas as pd
import numpy as np
movie = pd.read_csv('movie_metadata.csv')
for item in list(movie.columns):
    print(item)
    print("Test for correlation between duration & imdb score of movie")
    print(movie['duration'].corr(movie['imdb_score']))
    print()
    print("Test for correlation between budget & imdb score of movie")
    print(movie['budget'].corr(movie['imdb_score']))
    print()
    print("Test for correlation between cast_total_facebook_likes & imdb score of movie")
    print(movie['cast_total_facebook_likes'].corr(movie['imdb_score']))
    print()
    print("Test for correlation between gross & imdb score of movie")
    print(movie['gross'].corr(movie['imdb_score']))
    print()
    print("Test for correlation between movie_facebook_likes & imdb score of movie")
    print(movie['movie_facebook_likes'].corr(movie['imdb_score']))
    print()

    print(np.mean(movie['imdb_score']))
    print(np.mean(movie['budget']))
    print(max(movie['imdb_score']))
    print(min(movie['imdb_score']))

    plot_keywords = movie['plot_keywords']
    print(plot_keywords[0])
    print(plot_keywords[3])
    print(len(plot_keywords))
    best_movies = movie.loc[movie['imdb_score'] >= 8 ]
    the_best_keywords = best_movies['plot_keywords']

    print()
    my_list = []
    for item in the_best_keywords:
        my_string = str(item)
        ky_wrds_list = my_string.split('|')
        for k_wrd in ky_wrds_list:
            my_list.append(k_wrd)

    hit_plt_words = dict((x,my_list.count(x)) for x in set(my_list))
    print(max(hit_plt_words.values()))
    print(min(hit_plt_words.values()))
    print()
    print("The most common plot words for movies in IMDB with a rating greater than or equal to 8 are: ")
    print()
    for keys in hit_plt_words:
        #if hit_plt_words[keys] == max(hit_plt_words.values()):
        if hit_plt_words[keys] >= 6 and keys != 'nan':
            print(str(keys) + ": " + str(hit_plt_words[keys]))
            #print(keys)
    print()
