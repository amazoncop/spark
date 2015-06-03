our %schema = (
  'port' => {
    'instances' => 1800000,
    'id'   => { 'type' => 'auto', },
    'node' => { 'type' => 'node', 'range' => [qw/0 1999/], },
    'port' => { 'type' => 'port', 'range' => [qw/1 9/] },
  },
);
