our %schema = (
  'queue' => {
    'instances' => 10000000,
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
  },
);
