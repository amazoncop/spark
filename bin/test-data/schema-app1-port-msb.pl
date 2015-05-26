our %schema = (
  'port' => {
    'instances' => 100000,
    'node' => {
      'type' => 'node',
      'range' => [qw/0 99999/],
    },
    'port' => {
      'type' => 'port',
      'range' => [qw/1 9/]
    },
    'egressRate' => { 'type' => 'set', 'pool' => [qw/100 100 100 100 100 100 100 100 100 100 100 100 250 250 250 500 500 750/] },
    'pirOverrideLow'  => -2,
    'pirOverrideHigh' => -2,
  },
);
