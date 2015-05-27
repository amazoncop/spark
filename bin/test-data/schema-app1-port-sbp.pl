our %schema = (
  'port' => {
    'instances' => 100000,
    'node' => {
      'type' => 'node',
      'range' => [qw/0 99999/],
    },
    'port' => {
      'type' => 'port',
      'range' => [qw/1 3/]
    },
    'egressRate' => { 'type' => 'set', 'pool' => [qw/-1/] },
    'pirOverrideLow'  => { 'type' => 'set', 'pool' => [qw/100 300/] },
    'pirOverrideHigh' => { 'type' => 'set', 'pool' => [qw/500 1100/] },
  },
);
