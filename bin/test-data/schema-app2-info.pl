our %schema = (
  'port' => {
    'instances' => 170000,
    'portId' => {
      'type' => 'auto',
    },
    'node' => {
      'type' => 'node',
      'range' => [qw/0 999/],
    },
    'port' => {
      'type' => 'port',
      'range' => [qw/1 4/]
    },
  },
);
