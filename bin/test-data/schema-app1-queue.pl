our %schema = (
  'queue' => {
    'instances' => 100000,
    'node' => {
      'type' => 'node',
      'range' => [qw/0 9999/],
    },
    'port' => {
      'type' => 'port',
      'range' => [qw/1 3/]
    },
    'queue' => {
      'type' => 'set',
      'pool' => [qw/2 3 5 6/]
    },
  },
);
