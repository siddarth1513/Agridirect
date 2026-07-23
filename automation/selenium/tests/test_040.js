describe('Selenium Test 40', () => {
    it('should perform action 40', async () => {
        await browser.url('https://example.com');
        // TODO: add real steps
        expect(await browser.getTitle()).toBe('Example Domain');
    });
});
