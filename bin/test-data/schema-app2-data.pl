our %schema = (
  'data' => {
    'instances' => 1800000,
    'portId' => {
      'type' => 'int',
      'range' => [qw/0 170000/]
    },
    'timestamp' => {
      'type' => 'timestamp',
      'range' => 60*60*24*365,
      'rounding' => 900,
    },
    'value' => {
      'type' => 'int',
      'range' => [qw/0 99999999/]
    },
  },
);
