our %schema = (
  'port' => {
    'instances' => 20000000,
    'avcId' => { 'type' => 'auto', },
    'cvcId' => {
      'type' => 'int',
      'range' => [qw/0 50000/]
    },
  },
);
