our %schema = (
  'data' => {
    'instances' => 140000,
    'id' => { 'type' => 'auto', },
    'timestamp' => { 'type' => 'timestamp', 'range' => 60*60*24*365, 'rounding' => 900, },
    'value' => { 'type' => 'int', 'range' => [qw/0 99999999/] },
  },
);
