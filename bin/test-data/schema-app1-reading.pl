our %schema = (
  'reading' => {
    'instances' => 100000000,
    'id' => {
      'type' => 'reading',
      'range' => [qw/0 999999/]
    },
    'value' => {
      'type' => 'int',
      'range' => [qw/0 99999/]
    },
    'timestamp' => {
      'type' => 'timestamp',
      'range' => 60*60*24*365,
      'rounding' => 900,
    }
  },
);
