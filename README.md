## Information

| Package      | groovr | 0-9g/day      |

| Description  | Grooveshark API Client |

| Node Version | >= 0.4                 |



## Usage

This should also run in the browser if the dependencies are met.

```
groovr = require 'groovy'

# You can search songs, artists, and albums
groovr.search {type:"Songs", query:"flying lotus"}, (err, songs) ->
  ###
  [ { SongID: '24404869',
    AlbumID: '3974162',
    ArtistID: '51859',
    GenreID: '0',
    SongName: 'Do the Astral Plane',
    AlbumName: 'Cosmogramma',
    ArtistName: 'Flying Lotus',
    Year: '2010',
    TrackNum: '10',
    CoverArtFilename: '3974162.jpg',
    ArtistCoverArtFilename: '',
    TSAdded: '1358875473',
    AvgRating: '0.000000',
    AvgDuration: '0.000000',
    EstimateDuration: '0.000000',
    Flags: 0,
    IsLowBitrateAvailable: '0',
    IsVerified: '1',
    Popularity: 1313207069,
    Score: 143901.31126353,
    RawScore: 0,
    PopularityIndex: 7069 },
    ...
   ]

  ###

  groovr.getSongFile songs[0].SongID, (err, file) ->
    ###
    file.url is an mp3 url you can download
    the file object also contains some meta info like song length
    ###

# You can also get the latest popular songs
groovr.getPopular (err, songs) ->

# You can specify a date range - the default is daily
groovr.getPopular 'monthly', (err, songs) ->
```

## LICENSE

(MIT License)

Copyright (c) 2013 Fractal contact@wearefractal.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.