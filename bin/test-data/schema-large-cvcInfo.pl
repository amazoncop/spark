our %schema = (
  'port' => {
    'instances' => 50000,
    'cvcId' => { 'type' => 'auto', },
    'description' => {
      'type' => 'set',
      'range' => [qw/acme1 acme2 acme3 acme4 acme5 acme6 acme7 acme8 acme9 robco1 robco2/]
    },
  },
);
