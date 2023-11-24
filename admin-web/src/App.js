import React from 'react';
import { ChakraProvider } from '@chakra-ui/react';
import { BrowserRouter, Route, Switch, Redirect } from 'react-router-dom';
import AuthLayout from 'layouts/auth';
import AdminLayout from 'layouts/admin';
import theme from 'theme/theme';
import { useEffect, useState } from 'react';

function App() {
  const [user, setUser] = useState({});

  useEffect(() => {
    const value = localStorage.getItem('USER');
    setUser(JSON.parse(value));
  }, [localStorage.getItem('USER')]);

  return (
    <ChakraProvider theme={theme}>
      <BrowserRouter>
        <Switch>
          <Route path={`/auth`} component={AuthLayout} />
          {user !== null && <Route path={`/admin`} component={AdminLayout} />}
          <Redirect from="/" to="/auth/sign-in" />
        </Switch>
      </BrowserRouter>
    </ChakraProvider>
  );
}

export default App;
