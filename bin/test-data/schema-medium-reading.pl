our %schema = (
  'reading' => {
    'instances' => 100000000,
    'readingId' => {
      'type' => 'reading',
      'range' => [qw/0 999999/]
    },
    'node' => {
      'type' => 'node',
      'range' => [qw/0 99999/],
    },
    'port' => {
      'type' => 'port',
      'range' => [qw/1 9/]
    },
    'queue' => {
      'type' => 'set',
      'pool' => [qw/2 3 5 6/]
    },
    'timestamp' => {
      'type' => 'timestamp',
      'range' => 60*60*24*365,
      'rounding' => 900,
    },
    'value' => {
      'type' => 'int',
      'range' => [qw/0 99999/]
    },
  },
);
