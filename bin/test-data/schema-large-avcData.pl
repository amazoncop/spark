our %schema = (
  'port' => {
    'instances' => 20000000,
    'avcId' => { 'type' => 'auto', },
    'octetsIn' => {
      'type' => 'int',
      'range' => [qw/1 10000000/]
    },
    'octetsOut' => {
      'type' => 'int',
      'range' => [qw/1 10000000/]
    },
  },
);
