import { Box, Grid } from '@chakra-ui/react';

// Custom components
import Banner from 'views/admin/profile/components/Banner';

// Assets
import banner from 'assets/img/auth/banner.png';
import avatar from 'assets/img/avatars/avatar4.png';
import React from 'react';
import { useEffect, useState } from 'react';

export default function Overview() {

  const [user, setUser] = useState({});

  useEffect(() => {
    const value = localStorage.getItem('USER');
    setUser(JSON.parse(value));
  }, [localStorage.getItem('USER')]);

  return (
    <Box pt={{ base: '130px', md: '80px', xl: '80px' }}>
      {/* Main Fields */}
      <Grid
        templateColumns={{
          base: '1fr',
          lg: '1fr',
        }}
      >
        <Banner
          gridArea="1 / 1 / 2 / 2"
          banner={banner}
          name={user?.fullname?.stringValue}
          email={user?.email?.stringValue}
        />
      </Grid>
    </Box>
  );
}
