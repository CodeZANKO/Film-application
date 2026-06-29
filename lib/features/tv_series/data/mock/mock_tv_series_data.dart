import '../models/tv_series_model.dart';

const List<TVSeries> mockTVSeriesData = [
  TVSeries(
    id: '1',
    title: 'Stranger Things',
    overview: 'When a young boy disappears, his mother, a police chief and his friends must confront terrifying supernatural forces in order to get him back.',
    posterUrl: 'https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?q=80&w=500',
    backdropUrl: 'https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?q=80&w=800',
    rating: 8.7,
    genre: 'Sci-Fi & Fantasy',
    releaseYear: 2016,
    totalSeasons: 4,
    seasons: [
      Season(
        seasonNumber: 1,
        episodes: [
          Episode(
            episodeNumber: 1,
            title: 'The Vanishing of Will Byers',
            duration: '48 mins',
            thumbnailUrl: 'https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?q=80&w=500',
            videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
          ),
          Episode(
            episodeNumber: 2,
            title: 'The Weirdo on Maple Street',
            duration: '55 mins',
            thumbnailUrl: 'https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?q=80&w=500',
            videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
          ),
        ],
      ),
      Season(
        seasonNumber: 2,
        episodes: [
          Episode(
            episodeNumber: 1,
            title: 'MADMAX',
            duration: '48 mins',
            thumbnailUrl: 'https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?q=80&w=500',
            videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
          ),
        ],
      ),
    ],
    cast: [
      SeriesCast(
        id: '1',
        name: 'Millie Bobby Brown',
        character: 'Eleven',
        profileUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=200',
      ),
      SeriesCast(
        id: '2',
        name: 'Finn Wolfhard',
        character: 'Mike Wheeler',
        profileUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=200',
      ),
      SeriesCast(
        id: '3',
        name: 'Winona Ryder',
        character: 'Joyce Byers',
        profileUrl: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?q=80&w=200',
      ),
      SeriesCast(
        id: '4',
        name: 'David Harbour',
        character: 'Jim Hopper',
        profileUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200',
      ),
      SeriesCast(
        id: '5',
        name: 'Gaten Matarazzo',
        character: 'Dustin Henderson',
        profileUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=200',
      ),
    ],
  ),
  TVSeries(
    id: '2',
    title: 'The Boys',
    overview: 'A group of vigilantes set out to take down corrupt superheroes who abuse their superpowers.',
    posterUrl: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=500',
    backdropUrl: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=800',
    rating: 8.7,
    genre: 'Action & Adventure',
    releaseYear: 2019,
    totalSeasons: 3,
    seasons: [
      Season(
        seasonNumber: 1,
        episodes: [
          Episode(
            episodeNumber: 1,
            title: 'The Name of the Game',
            duration: '60 mins',
            thumbnailUrl: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=500',
            videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
          ),
        ],
      ),
    ],
    cast: [
      SeriesCast(
        id: '10',
        name: 'Karl Urban',
        character: 'Billy Butcher',
        profileUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=200',
      ),
      SeriesCast(
        id: '11',
        name: 'Jack Quaid',
        character: 'Hughie Campbell',
        profileUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=200',
      ),
      SeriesCast(
        id: '12',
        name: 'Antony Starr',
        character: 'Homelander',
        profileUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200',
      ),
      SeriesCast(
        id: '13',
        name: 'Erin Moriarty',
        character: 'Starlight',
        profileUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=200',
      ),
    ],
  ),
  TVSeries(
    id: '3',
    title: 'The Mandalorian',
    overview: 'A lone gunfighter makes his way through the outer reaches of the galaxy, far from the authority of the New Republic.',
    posterUrl: 'https://images.unsplash.com/photo-1594909122845-11baa439b7bf?q=80&w=500',
    backdropUrl: 'https://images.unsplash.com/photo-1594909122845-11baa439b7bf?q=80&w=800',
    rating: 8.4,
    genre: 'Sci-Fi & Fantasy',
    releaseYear: 2019,
    totalSeasons: 3,
    seasons: [
      Season(
        seasonNumber: 1,
        episodes: [
          Episode(
            episodeNumber: 1,
            title: 'Chapter 1: The Mandalorian',
            duration: '39 mins',
            thumbnailUrl: 'https://images.unsplash.com/photo-1594909122845-11baa439b7bf?q=80&w=500',
            videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4',
          ),
        ],
      ),
    ],
  ),
  TVSeries(
    id: '4',
    title: 'Breaking Bad',
    overview: 'A high school chemistry teacher diagnosed with inoperable lung cancer turns to manufacturing and selling methamphetamine in order to secure his family\'s future.',
    posterUrl: 'https://images.unsplash.com/photo-1551269901-5c5e14c25df7?q=80&w=500',
    backdropUrl: 'https://images.unsplash.com/photo-1551269901-5c5e14c25df7?q=80&w=800',
    rating: 8.9,
    genre: 'Drama',
    releaseYear: 2008,
    totalSeasons: 5,
    seasons: [
      Season(
        seasonNumber: 1,
        episodes: [
          Episode(
            episodeNumber: 1,
            title: 'Pilot',
            duration: '58 mins',
            thumbnailUrl: 'https://images.unsplash.com/photo-1551269901-5c5e14c25df7?q=80&w=500',
            videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4',
          ),
        ],
      ),
    ],
  ),
];

