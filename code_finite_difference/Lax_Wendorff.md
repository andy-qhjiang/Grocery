Let’s derive the Lax-Wendroff numerical flux for the nonlinear conservation law \( u_t + (f(u))_x = 0 \) from scratch, constructing it step-by-step to ensure it’s second-order accurate in both space and time. Our goal is to find the numerical flux \( F(u, v) \) such that the scheme \( u_j^{n+1} = u_j^n - \frac{k}{h} (F_{j+1/2} - F_{j-1/2}) \) matches the true solution up to the desired accuracy, and we’ll verify the error term explicitly. This will be a self-contained construction, starting from basic principles, so you can recreate it yourself.

---

### Step 1: Understand the Goal with a Taylor Expansion

To achieve second-order accuracy, the numerical scheme must approximate the solution \( u(x, t^{n+1}) \) at the next time step by capturing terms up to \( \mathcal{O}(k^2) \) in time and \( \mathcal{O}(h^2) \) in space (since \( k \) and \( h \) are typically related via a CFL condition, e.g., \( k = \mathcal{O}(h) \)). Start with a Taylor expansion of \( u \) in time at position \( x_j \):

\[ u(x_j, t^{n+1}) = u(x_j, t^n) + k \frac{\partial u}{\partial t} + \frac{k^2}{2} \frac{\partial^2 u}{\partial t^2} + \mathcal{O}(k^3) \]

We need to express the time derivatives using the conservation law \( u_t + f(u)_x = 0 \).

- **First time derivative**:

\[ u_t = -f(u)_x \]

\[ \frac{\partial u}{\partial t} = - \frac{\partial f(u)}{\partial x} \]

- **Second time derivative**:

Differentiate \( u_t = -f(u)_x \) with respect to time:

\[ \frac{\partial^2 u}{\partial t^2} = \frac{\partial}{\partial t} (-f(u)_x) = -\frac{\partial}{\partial x} \left( \frac{\partial f(u)}{\partial t} \right) \]

Since \( f(u) \) depends on \( u \), apply the chain rule:

\[ \frac{\partial f(u)}{\partial t} = f'(u) \frac{\partial u}{\partial t} = f'(u) (-f(u)_x) = -f'(u) f(u)_x \]

So:

\[ \frac{\partial^2 u}{\partial t^2} = -\frac{\partial}{\partial x} (-f'(u) f(u)_x) = \frac{\partial}{\partial x} (f'(u) f(u)_x) \]

Substitute into the Taylor expansion:

\[ u(x_j, t^{n+1}) = u(x_j, t^n) - k f(u)_x + \frac{k^2}{2} \frac{\partial}{\partial x} (f'(u) f(u)_x) + \mathcal{O}(k^3) \]

This is the exact solution we want our scheme to approximate when discretized.

---

### Step 2: Set Up the Conservative Scheme

We use a finite difference scheme in conservation form:

\[ u_j^{n+1} = u_j^n - \frac{k}{h} (F_{j+1/2} - F_{j-1/2}) \]

where \( F_{j+1/2} = F(u_j^n, u_{j+1}^n) \) is the numerical flux between cells \( j \) and \( j+1 \), and \( h \) is the spatial grid size. Our task is to design \( F(u, v) \) so that this scheme matches the Taylor expansion up to second-order terms.

---

### Step 3: Approximate the First-Order Term

First, consider the \( -k f(u)_x \) term. In a discrete setting, approximate the spatial derivative \( f(u)_x \) at \( x_j \) using a centered difference for second-order accuracy:

\[ f(u)_x \approx \frac{f(u_{j+1}^n) - f(u_{j-1}^n)}{2h} \]

This has an error of \( \mathcal{O}(h^2) \), since:

\[ f(u(x_{j+1})) = f(u(x_j)) + h f'(u) u_x + \frac{h^2}{2} f'(u) u_{xx} + \frac{h^2}{2} f''(u) u_x^2 + \mathcal{O}(h^3) \]

\[ f(u(x_{j-1})) = f(u(x_j)) - h f'(u) u_x + \frac{h^2}{2} f'(u) u_{xx} - \frac{h^2}{2} f''(u) u_x^2 + \mathcal{O}(h^3) \]

\[ \frac{f(u_{j+1}) - f(u_{j-1})}{2h} = f'(u) u_x + \mathcal{O}(h^2) = f(u)_x + \mathcal{O}(h^2) \]

So:

\[ u_j^{n+1} \approx u_j^n - k \frac{f(u_{j+1}^n) - f(u_{j-1}^n)}{2h} \]

In flux form, this suggests:

\[ F_{j+1/2} - F_{j-1/2} \approx \frac{f(u_{j+1}^n) - f(u_{j-1}^n)}{2} \]

A simple choice is:

\[ F(u, v) = \frac{f(u) + f(v)}{2} \]

Check it:

\[ F_{j+1/2} = \frac{f(u_j^n) + f(u_{j+1}^n)}{2} \]

\[ F_{j-1/2} = \frac{f(u_{j-1}^n) + f(u_j^n)}{2} \]

\[ F_{j+1/2} - F_{j-1/2} = \frac{f(u_{j+1}^n) + f(u_j^n)}{2} - \frac{f(u_{j-1}^n) + f(u_j^n)}{2} = \frac{f(u_{j+1}^n) - f(u_{j-1}^n)}{2} \]

\[ u_j^{n+1} = u_j^n - \frac{k}{h} \cdot \frac{f(u_{j+1}^n) - f(u_{j-1}^n)}{2} \]

This matches the first term, but it’s only first-order in time because it ignores the \( \frac{k^2}{2} \) term.

---

### Step 4: Incorporate the Second-Order Term

To include \( \frac{k^2}{2} \frac{\partial}{\partial x} (f'(u) f(u)_x) \), approximate it discretely. This term represents the curvature of the flux. Compute it as a finite difference of the quantity \( f'(u) f(u)_x \) across cell interfaces:

\[ \frac{\partial}{\partial x} (f'(u) f(u)_x) \approx \frac{(f'(u) f(u)_x)_{j+1/2} - (f'(u) f(u)_x)_{j-1/2}}{h} \]

At the interface \( x_{j+1/2} \), approximate:

- \( u \approx \frac{u_j + u_{j+1}}{2} \)

- \( f(u)_x \approx \frac{f(u_{j+1}) - f(u_j)}{h} \)

So:

\[ (f'(u) f(u)_x)_{j+1/2} \approx f'\left( \frac{u_j + u_{j+1}}{2} \right) \frac{f(u_{j+1}) - f(u_j)}{h} \]

Similarly:

\[ (f'(u) f(u)_x)_{j-1/2} \approx f'\left( \frac{u_{j-1} + u_j}{2} \right) \frac{f(u_j) - f(u_{j-1})}{h} \]

Then:

\[ \frac{\partial}{\partial x} (f'(u) f(u)_x) \approx \frac{1}{h} \left[ f'\left( \frac{u_j + u_{j+1}}{2} \right) \frac{f(u_{j+1}) - f(u_j)}{h} - f'\left( \frac{u_{j-1} + u_j}{2} \right) \frac{f(u_j) - f(u_{j-1})}{h} \right] \]

Include in the scheme:

\[ u_j^{n+1} = u_j^n - k \frac{f(u_{j+1}^n) - f(u_{j-1}^n)}{2h} + \frac{k^2}{2} \cdot \frac{1}{h} \left[ f'\left( \frac{u_j + u_{j+1}}{2} \right) \frac{f(u_{j+1}) - f(u_j)}{h} - f'\left( \frac{u_{j-1} + u_j}{2} \right) \frac{f(u_j) - f(u_{j-1})}{h} \right] \]

Rewrite the second term:

\[ \frac{k^2}{2 h^2} \left[ f'\left( \frac{u_j + u_{j+1}}{2} \right) (f(u_{j+1}) - f(u_j)) - f'\left( \frac{u_{j-1} + u_j}{2} \right) (f(u_j) - f(u_{j-1})) \right] \]

Adjust the flux:

\[ F_{j+1/2} - F_{j-1/2} = \frac{f(u_{j+1}) - f(u_{j-1})}{2} - \frac{k}{2h} \left[ f'\left( \frac{u_j + u_{j+1}}{2} \right) (f(u_{j+1}) - f(u_j)) - f'\left( \frac{u_{j-1} + u_j}{2} \right) (f(u_j) - f(u_{j-1})) \right] \]

Propose:

\[ F(u, v) = \frac{f(u) + f(v)}{2} - \frac{k}{2h} f'\left( \frac{u + v}{2} \right) (f(v) - f(u)) \]

Verify:

\[ F_{j+1/2} = \frac{f(u_j) + f(u_{j+1})}{2} - \frac{k}{2h} f'\left( \frac{u_j + u_{j+1}}{2} \right) (f(u_{j+1}) - f(u_j)) \]

\[ F_{j-1/2} = \frac{f(u_{j-1}) + f(u_j)}{2} - \frac{k}{2h} f'\left( \frac{u_{j-1} + u_j}{2} \right) (f(u_j) - f(u_{j-1})) \]

This matches our derivation.

---

### Step 5: Verify the Error Term

For a smooth solution, compute the local truncation error. Substitute Taylor expansions:

\[ u_{j \pm 1} = u_j \pm h u_x + \frac{h^2}{2} u_{xx} + \mathcal{O}(h^3) \]

\[ f(u_{j+1}) = f(u_j) + h f' u_x + \frac{h^2}{2} (f' u_{xx} + f'' u_x^2) + \mathcal{O}(h^3) \]

First term:

\[ \frac{f(u_{j+1}) - f(u_{j-1})}{2h} = f(u)_x + \mathcal{O}(h^2) \]

Second term, evaluate at \( u_{j+1/2} = u_j + \frac{h}{2} u_x + \mathcal{O}(h^2) \):

\[ f'\left( \frac{u_j + u_{j+1}}{2} \right) = f'(u_j) + \mathcal{O}(h) \]

\[ f(u_{j+1}) - f(u_j) = h f' u_x + \mathcal{O}(h^2) \]

\[ f'\left( \frac{u_j + u_{j+1}}{2} \right) (f(u_{j+1}) - f(u_j)) = f'(u_j) h f(u)_x + \mathcal{O}(h^2) \]

Similarly for \( j-1/2 \), leading to:

\[ \frac{\partial}{\partial x} (f'(u) f(u)_x) + \mathcal{O}(h) \]

Total error: \( \mathcal{O}(h^2) + \frac{k}{h} \mathcal{O}(h) = \mathcal{O}(h^2) + \mathcal{O}(k) \), which is second-order when \( k = \mathcal{O}(h) \).

---

### Final Flux

\[ F(u, v) = \frac{f(u) + f(v)}{2} - \frac{k}{2h} f'\left( \frac{u + v}{2} \right) (f(v) - f(u)) \]

This is the Lax-Wendroff flux, second-order accurate, derived from scratch!